
/* Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 and
 * only version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/leds-pmic8058.h>
#include <linux/pwm.h>
#include <linux/pmic8058-pwm.h>
#include <linux/hrtimer.h>
#include <linux/export.h>
#include <linux/timer.h>
#include <linux/workqueue.h>
#include <mach/pmic.h>
#include <mach/camera.h>
#include <mach/gpio.h>
#include "msm_camera_i2c.h"

struct flash_work {
	struct work_struct my_work;
	int    x;
};
struct flash_work *work;
#ifndef CONFIG_MSM_CAMERA_FLASH_LM3642
static struct timer_list flash_timer;
static int timer_state;
static struct workqueue_struct *flash_wq;
struct i2c_client *sx150x_client;
#endif
struct timer_list timer_flash;
static struct msm_camera_sensor_info *sensor_data;
static struct msm_camera_i2c_client i2c_client;
enum msm_cam_flash_stat{
	MSM_CAM_FLASH_OFF,
	MSM_CAM_FLASH_ON,
};

#ifdef CONFIG_MSM_CAMERA_FLASH_LM3642
//Define for register reference
#define	REG_ENABLE			(0xA)//ENABLE REGISTER (0x0A)
#define	REG_I_CTRL			(0x9)//CURRENT CONTROL REGISTER (0x09)

//Define for mode change and pin enable
#define	TX_PIN_EN_SHIFT			(6)
#define	STROBE_PIN_EN_SHIFT		(5)
#define	TORCH_PIN_EN_SHIFT		(4)
#define	MODE_BITS_SHIFT			(0)
#define	TX_PIN_EN_MASK			(0x1)
#define	STROBE_PIN_EN_MASK		(0x1)
#define	TORCH_PIN_EN_MASK		(0x1)
#define EX_PIN_ENABLE_MASK		(0x70)
#define	MODE_BITS_MASK			(0x73)

//Define for current control
#define	TORCH_I_MASK			(0x7)
#define	FLASH_I_MASK			(0xF)
#define	TORCH_I_SHIFT			(4)
#define	FLASH_I_SHIFT			(0)


enum lm3642_mode {
	MODES_STASNDBY = 0,
	MODES_INDIC,
	MODES_TORCH,
	MODES_FLASH
};

enum lm3642_pin_enable {
	PIN_DISABLED = 0,
	PIN_ENABLED,
};

enum lm3642_torch_current_val{
    TORCH_OFF,
	TORCH_46P88_MA,//Default
	TORCH_93P74_MA,
	TORCH_140P63_MA,
	TORCH_187P5_MA,
	TORCH_234P38_MA,
	TORCH_281P25_MA,
    TORCH_328P13_MA,
    TORCH_375_MA,
};

enum lm3642_flash_current_val{
    FLASH_OFF,
	FLASH_93P75_MA,
	FLASH_187P5_MA,
	FLASH_281P25_MA,
	FLASH_375_MA,
	FLASH_468P75_MA,
	FLASH_562P5_MA,
	FLASH_656P25_MA,
	FLASH_750_MA,
	FLASH_843P75_MA,
	FLASH_937P5_MA,
	FLASH_1031P25_MA,
	FLASH_1125_MA,
	FLASH_1218P75_MA,
	FLASH_1312P5_MA,
	FLASH_1406P25_MA,
	FLASH_1500_MA,//Default
};

static int lm3642_write_bits(uint8_t reg, uint8_t val, uint8_t mask, uint8_t shift)
{
    int rc = 0;
    uint16_t reg_val = 0;
    
    rc = msm_camera_i2c_read(&i2c_client, reg, &reg_val, MSM_CAMERA_I2C_BYTE_DATA);
	if (rc < 0) {
		pr_err("lm3642_write_bits: msm_camera_i2c_read(0x%x) failed! rc = %d\n", reg, rc);
		goto error;
	}
    CDBG("lm3642_write_bits: Before: msm_camera_i2c_read(0x%x) = 0x%x .\n", reg, reg_val);

    reg_val &= (~(mask << shift));
    reg_val |= ((val & mask) << shift);

    printk("lm3642_write_bits: Set reg_0x%x = 0x%x .\n", reg, reg_val);
    rc = msm_camera_i2c_write(&i2c_client, reg, reg_val, MSM_CAMERA_I2C_BYTE_DATA);
    if (rc < 0) {
        pr_err("lm3642_write_bits: msm_camera_i2c_write(0x%x) failed! rc = %d\n", reg, rc);
        goto error;
    }

    rc = msm_camera_i2c_read(&i2c_client, reg, &reg_val, MSM_CAMERA_I2C_BYTE_DATA);
    if (rc < 0) {
        pr_err("lm3642_write_bits: msm_camera_i2c_read(0x%x) failed! rc = %d\n", reg, rc);
        goto error;
    }
    CDBG("lm3642_write_bits: After: msm_camera_i2c_read(0x%x) = 0x%x .\n", reg, reg_val);

error:
    return rc;
}

static int lm3642_init( enum lm3642_pin_enable torch_pin_en, 
                         enum lm3642_pin_enable strobe_pin_en, 
                         enum lm3642_pin_enable tx_pin_en)
{
    int rc = 0;
    uint16_t reg_val = 0;

	/*set enable register */
    rc = msm_camera_i2c_read(&i2c_client, REG_ENABLE, &reg_val, MSM_CAMERA_I2C_BYTE_DATA);
	if (rc < 0) {
		pr_err("lm3642_init: msm_camera_i2c_read(0x%x) failed! rc = %d\n", REG_ENABLE, rc);
		goto error;
	}
    CDBG("lm3642_init: msm_camera_i2c_read(0x%x) = 0x%x .\n", REG_ENABLE, reg_val);

	reg_val &= (~EX_PIN_ENABLE_MASK);
	reg_val |= ((torch_pin_en & 0x01) << TORCH_PIN_EN_SHIFT);
	reg_val |= ((strobe_pin_en & 0x01) << STROBE_PIN_EN_SHIFT);
	reg_val |= ((tx_pin_en & 0x01) << TX_PIN_EN_SHIFT);

    rc = msm_camera_i2c_write(&i2c_client, REG_ENABLE, reg_val, MSM_CAMERA_I2C_BYTE_DATA);
    if (rc < 0) {
        pr_err("lm3642_init: msm_camera_i2c_write(0x%x) failed! rc = %d\n", REG_ENABLE, rc);
        goto error;
    }
    CDBG("lm3642_init: Set reg_0x%x = 0x%x .\n", REG_ENABLE, reg_val);

error:
    return rc;

}

static int lm3642_control(uint8_t brightness, enum lm3642_mode opmode, 
                             enum lm3642_pin_enable torch_pin_en, 
                             enum lm3642_pin_enable strobe_pin_en,
                             enum lm3642_pin_enable tx_pin_en)
{
	int rc = 0;

	/*brightness 0 means off-state */
	if (!brightness)
		opmode = MODES_STASNDBY;

    /*Set current value*/
	switch (opmode) {
	case MODES_TORCH:
        printk("lm3642_control: case MODES_TORCH ~ brightness = %d\n", brightness);
		rc = lm3642_write_bits(REG_I_CTRL,
				  brightness - 1, TORCH_I_MASK, TORCH_I_SHIFT);

		if (torch_pin_en)
			opmode |= (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
		break;

	case MODES_FLASH:
        printk("lm3642_control: case MODES_FLASH ~ brightness = %d\n", brightness);
		rc = lm3642_write_bits(REG_I_CTRL,
				  brightness - 1, FLASH_I_MASK, FLASH_I_SHIFT);
		if (strobe_pin_en)
			opmode |= (STROBE_PIN_EN_MASK << STROBE_PIN_EN_SHIFT);
		break;

	case MODES_INDIC:
        printk("lm3642_control: case MODES_INDIC ~ brightness = %d\n", brightness);
		rc = lm3642_write_bits(REG_I_CTRL,
				  brightness - 1, TORCH_I_MASK, TORCH_I_SHIFT);
		break; 
		
	case MODES_STASNDBY:
		printk("lm3642_control: case MODES_STASNDBY ~ brightness = %d\n", brightness);
		break;

	default:
		return -ENOTSUPP;
	}
	if (rc < 0){   
        pr_err("lm3642_control: Set brightness = %d fail !\n", brightness);
		goto error;
    }
    
	if (tx_pin_en)
		opmode |= (TX_PIN_EN_MASK << TX_PIN_EN_SHIFT);

    /*Set mode and control pin*/
	rc = lm3642_write_bits(REG_ENABLE,
			  opmode, MODE_BITS_MASK, MODE_BITS_SHIFT);
	if (rc < 0){   
        pr_err("lm3642_control: Set mode and control pin fail !\n");
		goto error;
    }

    CDBG("lm3642_control: torch_pin_en = %d, strobe_pin_en = %d, tx_pin_en = %d,\n", torch_pin_en, strobe_pin_en, tx_pin_en);
error:
	return rc;
}


static struct i2c_client *lm3642_client;

static const struct i2c_device_id lm3642_i2c_id[] = {
	{"lm3642", 0},
	{ }
};

static int lm3642_i2c_probe(struct i2c_client *client,
		const struct i2c_device_id *id)
{
	int rc = 0;
	CDBG("%s enter\n", __func__);

	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		pr_err("i2c_check_functionality failed\n");
		goto probe_failure;
	}

	lm3642_client = client;
	i2c_client.client = lm3642_client;
	i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
	rc = lm3642_init(PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
	if (rc < 0) {
		lm3642_client = NULL;
		goto probe_failure;
	}

	CDBG("%s success! rc = %d\n", __func__, rc);
	return 0;

probe_failure:
	pr_err("%s failed! rc = %d\n", __func__, rc);
	return rc;
}

static struct i2c_driver lm3642_i2c_driver = {
	.id_table = lm3642_i2c_id,
	.probe  = lm3642_i2c_probe,
	.remove = __exit_p(lm3642_i2c_remove),
	.driver = {
		.name = "lm3642",
	},
};
#else
static struct i2c_client *sc628a_client;

static const struct i2c_device_id sc628a_i2c_id[] = {
	{"sc628a", 0},
	{ }
};

static int sc628a_i2c_probe(struct i2c_client *client,
		const struct i2c_device_id *id)
{
	int rc = 0;
	CDBG("sc628a_probe called!\n");

	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		pr_err("i2c_check_functionality failed\n");
		goto probe_failure;
	}

	sc628a_client = client;

	CDBG("sc628a_probe success rc = %d\n", rc);
	return 0;

probe_failure:
	pr_err("sc628a_probe failed! rc = %d\n", rc);
	return rc;
}

static struct i2c_driver sc628a_i2c_driver = {
	.id_table = sc628a_i2c_id,
	.probe  = sc628a_i2c_probe,
	.remove = __exit_p(sc628a_i2c_remove),
	.driver = {
		.name = "sc628a",
	},
};

static struct i2c_client *tps61310_client;

static const struct i2c_device_id tps61310_i2c_id[] = {
	{"tps61310", 0},
	{ }
};

static int tps61310_i2c_probe(struct i2c_client *client,
		const struct i2c_device_id *id)
{
	int rc = 0;
	CDBG("%s enter\n", __func__);

	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		pr_err("i2c_check_functionality failed\n");
		goto probe_failure;
	}

	tps61310_client = client;
	i2c_client.client = tps61310_client;
	i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
	rc = msm_camera_i2c_write(&i2c_client, 0x01, 0x00,
		MSM_CAMERA_I2C_BYTE_DATA);
	if (rc < 0) {
		tps61310_client = NULL;
		goto probe_failure;
	}

	CDBG("%s success! rc = %d\n", __func__, rc);
	return 0;

probe_failure:
	pr_err("%s failed! rc = %d\n", __func__, rc);
	return rc;
}

static struct i2c_driver tps61310_i2c_driver = {
	.id_table = tps61310_i2c_id,
	.probe  = tps61310_i2c_probe,
	.remove = __exit_p(tps61310_i2c_remove),
	.driver = {
		.name = "tps61310",
	},
};
#endif
//FIH-SW-MM-MC-BringUpLM3642ForCameraFlashLed-00+}

static int config_flash_gpio_table(enum msm_cam_flash_stat stat,
			struct msm_camera_sensor_strobe_flash_data *sfdata)
{
	int rc = 0, i = 0;
	int msm_cam_flash_gpio_tbl[][2] = {
		{sfdata->flash_trigger, 1},
		{sfdata->flash_charge, 1},
		{sfdata->flash_charge_done, 0}
	};

	if (stat == MSM_CAM_FLASH_ON) {
		for (i = 0; i < ARRAY_SIZE(msm_cam_flash_gpio_tbl); i++) {
			rc = gpio_request(msm_cam_flash_gpio_tbl[i][0],
							  "CAM_FLASH_GPIO");
			if (unlikely(rc < 0)) {
				pr_err("%s not able to get gpio\n", __func__);
				for (i--; i >= 0; i--)
					gpio_free(msm_cam_flash_gpio_tbl[i][0]);
				break;
			}
			if (msm_cam_flash_gpio_tbl[i][1])
				gpio_direction_output(
					msm_cam_flash_gpio_tbl[i][0], 0);
			else
				gpio_direction_input(
					msm_cam_flash_gpio_tbl[i][0]);
		}
	} else {
		for (i = 0; i < ARRAY_SIZE(msm_cam_flash_gpio_tbl); i++) {
			gpio_direction_input(msm_cam_flash_gpio_tbl[i][0]);
			gpio_free(msm_cam_flash_gpio_tbl[i][0]);
		}
	}
	return rc;
}

int msm_camera_flash_current_driver(
	struct msm_camera_sensor_flash_current_driver *current_driver,
	unsigned led_state)
{
	int rc = 0;
#if defined CONFIG_LEDS_PMIC8058
	int idx;
	const struct pmic8058_leds_platform_data *driver_channel =
		current_driver->driver_channel;
	int num_leds = driver_channel->num_leds;

	CDBG("%s: led_state = %d\n", __func__, led_state);

	/* Evenly distribute current across all channels */
	switch (led_state) {
	case MSM_CAMERA_LED_OFF:
		for (idx = 0; idx < num_leds; ++idx) {
			rc = pm8058_set_led_current(
				driver_channel->leds[idx].id, 0);
			if (rc < 0)
				pr_err(
					"%s: FAIL name = %s, rc = %d\n",
					__func__,
					driver_channel->leds[idx].name,
					rc);
		}
		break;

	case MSM_CAMERA_LED_LOW:
		for (idx = 0; idx < num_leds; ++idx) {
			rc = pm8058_set_led_current(
				driver_channel->leds[idx].id,
				current_driver->low_current/num_leds);
			if (rc < 0)
				pr_err(
					"%s: FAIL name = %s, rc = %d\n",
					__func__,
					driver_channel->leds[idx].name,
					rc);
		}
		break;

	case MSM_CAMERA_LED_HIGH:
		for (idx = 0; idx < num_leds; ++idx) {
			rc = pm8058_set_led_current(
				driver_channel->leds[idx].id,
				current_driver->high_current/num_leds);
			if (rc < 0)
				pr_err(
					"%s: FAIL name = %s, rc = %d\n",
					__func__,
					driver_channel->leds[idx].name,
					rc);
		}
		break;
	case MSM_CAMERA_LED_INIT:
	case MSM_CAMERA_LED_RELEASE:
		break;

	default:
		rc = -EFAULT;
		break;
	}
	CDBG("msm_camera_flash_led_pmic8058: return %d\n", rc);
#endif /* CONFIG_LEDS_PMIC8058 */
	return rc;
}

int msm_camera_flash_led(
		struct msm_camera_sensor_flash_external *external,
		unsigned led_state)
{
	int rc = 0;

	CDBG("msm_camera_flash_led: %d\n", led_state);
	switch (led_state) {
	case MSM_CAMERA_LED_INIT:
		rc = gpio_request(external->led_en, "sgm3141");
		CDBG("MSM_CAMERA_LED_INIT: gpio_req: %d %d\n",
				external->led_en, rc);
		if (!rc)
			gpio_direction_output(external->led_en, 0);
		else
			return 0;

		rc = gpio_request(external->led_flash_en, "sgm3141");
		CDBG("MSM_CAMERA_LED_INIT: gpio_req: %d %d\n",
				external->led_flash_en, rc);
		if (!rc)
			gpio_direction_output(external->led_flash_en, 0);

			break;

	case MSM_CAMERA_LED_RELEASE:
		CDBG("MSM_CAMERA_LED_RELEASE\n");
		gpio_set_value_cansleep(external->led_en, 0);
		gpio_free(external->led_en);
		gpio_set_value_cansleep(external->led_flash_en, 0);
		gpio_free(external->led_flash_en);
		break;

	case MSM_CAMERA_LED_OFF:
		CDBG("MSM_CAMERA_LED_OFF\n");
		gpio_set_value_cansleep(external->led_en, 0);
		gpio_set_value_cansleep(external->led_flash_en, 0);
		break;

	case MSM_CAMERA_LED_LOW:
		CDBG("MSM_CAMERA_LED_LOW\n");
		gpio_set_value_cansleep(external->led_en, 1);
		gpio_set_value_cansleep(external->led_flash_en, 1);
		break;

	case MSM_CAMERA_LED_HIGH:
		CDBG("MSM_CAMERA_LED_HIGH\n");
		gpio_set_value_cansleep(external->led_en, 1);
		gpio_set_value_cansleep(external->led_flash_en, 1);
		break;

	default:
		rc = -EFAULT;
		break;
	}

	return rc;
}

//FIH-SW-MM-MC-BringUpLM3642ForCameraFlashLed-00+{
#ifdef CONFIG_MSM_CAMERA_FLASH_LM3642
int msm_camera_flash_external(
	struct msm_camera_sensor_flash_external *external,
	unsigned led_state)
{
    int rc = 0;

	switch (led_state) {

	case MSM_CAMERA_LED_INIT:
        printk("msm_camera_flash_external: case MSM_CAMERA_LED_INIT ~\n");
		if (external->flash_id == MAM_CAMERA_EXT_LED_FLASH_LM3642) {
			if (!lm3642_client) {
				rc = i2c_add_driver(&lm3642_i2c_driver);
				if (rc < 0 || lm3642_client == NULL) {
					pr_err("lm3642_i2c_driver add failed\n");
					rc = -ENOTSUPP;
					return rc;
				}
			}
		} else {
			pr_err("Flash id not supported\n");
			rc = -ENOTSUPP;
			return rc;
		}

        rc = lm3642_init(PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
        if (rc < 0)
            pr_err("lm3642_init() fail !\n");
        break;

	case MSM_CAMERA_LED_RELEASE:
        printk("msm_camera_flash_external: case MSM_CAMERA_LED_RELEASE ~\n");

        CDBG("lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED)\n");
        rc = lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
        if (rc < 0)
            pr_err("lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED) fail !\n");

        if (lm3642_client) {
            i2c_del_driver(&lm3642_i2c_driver);
            lm3642_client = NULL;
        }
		break;

	case MSM_CAMERA_LED_OFF:
        printk("msm_camera_flash_external: case MSM_CAMERA_LED_OFF ~\n");

        CDBG("lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED)\n");
        rc = lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
        if (rc < 0)
            pr_err("lm3642_control(TORCH_OFF, MODES_STASNDBY, PIN_DISABLED) fail !\n");
		break;

	case MSM_CAMERA_LED_LOW:
        printk("msm_camera_flash_external: case MSM_CAMERA_LED_LOW ~\n");
/*MM-UW-Add torch current-00+{*/
        CDBG("lm3642_control(TORCH_140P63_MA, MODES_TORCH, PIN_DISABLED)\n");
        rc = lm3642_control(TORCH_140P63_MA, MODES_TORCH, PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
        if (rc < 0)
            pr_err("lm3642_control(TORCH_140P63_MA, MODES_TORCH) fail !\n");
		break;

	case MSM_CAMERA_LED_HIGH:
        printk("msm_camera_flash_external: case MSM_CAMERA_LED_HIGH ~\n");

        CDBG("lm3642_control(FLASH_843P75_MA, MODES_FLASH, PIN_DISABLED)\n");
        rc = lm3642_control(FLASH_843P75_MA, MODES_FLASH, PIN_DISABLED, PIN_DISABLED, PIN_DISABLED);
        if (rc < 0)
            pr_err("lm3642_control(FLASH_843P75_MA, MODES_FLASH) fail !\n");
/*MM-SL-Add torch current-00+}*/
		break;

	default:
		rc = -EFAULT;
		break;
	}
	return rc;
}

#else
static void flash_wq_function(struct work_struct *work)
{
	if (tps61310_client) {
		i2c_client.client = tps61310_client;
		i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
		msm_camera_i2c_write(&i2c_client, 0x01,
				0x46, MSM_CAMERA_I2C_BYTE_DATA);
	}
	return;
}

void flash_timer_callback(unsigned long data)
{
	queue_work(flash_wq, (struct work_struct *)work );
	mod_timer(&flash_timer, jiffies + msecs_to_jiffies(10000));
}

int msm_camera_flash_external(
	struct msm_camera_sensor_flash_external *external,
	unsigned led_state)
{
	int rc = 0;

	switch (led_state) {

	case MSM_CAMERA_LED_INIT:
		if (external->flash_id == MAM_CAMERA_EXT_LED_FLASH_SC628A) {
			if (!sc628a_client) {
				rc = i2c_add_driver(&sc628a_i2c_driver);
				if (rc < 0 || sc628a_client == NULL) {
					pr_err("sc628a_i2c_driver add failed\n");
					rc = -ENOTSUPP;
					return rc;
				}
			}
		} else if (external->flash_id ==
			MAM_CAMERA_EXT_LED_FLASH_TPS61310) {
			if (!tps61310_client) {
				rc = i2c_add_driver(&tps61310_i2c_driver);
				if (rc < 0 || tps61310_client == NULL) {
					pr_err("tps61310_i2c_driver add failed\n");
					rc = -ENOTSUPP;
					return rc;
				}
			}
		} else {
			pr_err("Flash id not supported\n");
			rc = -ENOTSUPP;
			return rc;
		}

#if defined(CONFIG_GPIO_SX150X) || defined(CONFIG_GPIO_SX150X_MODULE)
		if (external->expander_info && !sx150x_client) {
			struct i2c_adapter *adapter =
			i2c_get_adapter(external->expander_info->bus_id);
			if (adapter)
				sx150x_client = i2c_new_device(adapter,
					external->expander_info->board_info);
			if (!sx150x_client || !adapter) {
				pr_err("sx150x_client is not available\n");
				rc = -ENOTSUPP;
				if (sc628a_client) {
					i2c_del_driver(&sc628a_i2c_driver);
					sc628a_client = NULL;
				}
				if (tps61310_client) {
					i2c_del_driver(&tps61310_i2c_driver);
					tps61310_client = NULL;
				}
				return rc;
			}
			i2c_put_adapter(adapter);
		}
#endif
		if (sc628a_client)
			rc = gpio_request(external->led_en, "sc628a");
		if (tps61310_client)
			rc = gpio_request(external->led_en, "tps61310");

		if (!rc) {
			gpio_direction_output(external->led_en, 0);
		} else {
			goto error;
		}

		if (sc628a_client)
			rc = gpio_request(external->led_flash_en, "sc628a");
		if (tps61310_client)
			rc = gpio_request(external->led_flash_en, "tps61310");

		if (!rc) {
			gpio_direction_output(external->led_flash_en, 0);
			break;
		}

		if (sc628a_client || tps61310_client) {
			gpio_set_value_cansleep(external->led_en, 0);
			gpio_free(external->led_en);
		}
error:
		pr_err("%s gpio request failed\n", __func__);
		if (sc628a_client) {
			i2c_del_driver(&sc628a_i2c_driver);
			sc628a_client = NULL;
		}
		if (tps61310_client) {
			i2c_del_driver(&tps61310_i2c_driver);
			tps61310_client = NULL;
		}
		break;

	case MSM_CAMERA_LED_RELEASE:
		if (sc628a_client || tps61310_client) {
			gpio_set_value_cansleep(external->led_en, 0);
			gpio_free(external->led_en);
			gpio_set_value_cansleep(external->led_flash_en, 0);
			gpio_free(external->led_flash_en);
			if (sc628a_client) {
				i2c_del_driver(&sc628a_i2c_driver);
				sc628a_client = NULL;
			}
			if (tps61310_client) {
				if (timer_state) {
					del_timer(&flash_timer);
					kfree((void *)work);
					timer_state = 0;
				}
				i2c_del_driver(&tps61310_i2c_driver);
				tps61310_client = NULL;
			}
		}
#if defined(CONFIG_GPIO_SX150X) || defined(CONFIG_GPIO_SX150X_MODULE)
		if (external->expander_info && sx150x_client) {
			i2c_unregister_device(sx150x_client);
			sx150x_client = NULL;
		}
#endif
		break;

	case MSM_CAMERA_LED_OFF:
		if (sc628a_client || tps61310_client) {
			if (sc628a_client) {
				i2c_client.client = sc628a_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x02,
					0x00, MSM_CAMERA_I2C_BYTE_DATA);
			}
			if (tps61310_client) {
				i2c_client.client = tps61310_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x01,
					0x00, MSM_CAMERA_I2C_BYTE_DATA);
				if (timer_state) {
					del_timer(&flash_timer);
					kfree((void *)work);
					timer_state = 0;
				}
			}
			gpio_set_value_cansleep(external->led_en, 0);
			gpio_set_value_cansleep(external->led_flash_en, 0);
		}
		break;

	case MSM_CAMERA_LED_LOW:
		if (sc628a_client || tps61310_client) {
			gpio_set_value_cansleep(external->led_en, 1);
			gpio_set_value_cansleep(external->led_flash_en, 1);
			usleep_range(2000, 3000);
			if (sc628a_client) {
				i2c_client.client = sc628a_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x02,
					0x06, MSM_CAMERA_I2C_BYTE_DATA);
			}
			if (tps61310_client) {
				i2c_client.client = tps61310_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x01,
					0x46, MSM_CAMERA_I2C_BYTE_DATA);
				flash_wq = alloc_workqueue("my_queue",WQ_MEM_RECLAIM,1);
				work = (struct flash_work *)kmalloc(sizeof(struct flash_work), GFP_KERNEL);
				INIT_WORK( (struct work_struct *)work, flash_wq_function );
				setup_timer(&flash_timer, flash_timer_callback, 0);
				mod_timer(&flash_timer, jiffies + msecs_to_jiffies(10000));
				timer_state = 1;
			}
		}
		break;

	case MSM_CAMERA_LED_HIGH:
		if (sc628a_client || tps61310_client) {
			gpio_set_value_cansleep(external->led_en, 1);
			gpio_set_value_cansleep(external->led_flash_en, 1);
			usleep_range(2000, 3000);
			if (sc628a_client) {
				i2c_client.client = sc628a_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x02,
					0x49, MSM_CAMERA_I2C_BYTE_DATA);
			}
			if (tps61310_client) {
				i2c_client.client = tps61310_client;
				i2c_client.addr_type = MSM_CAMERA_I2C_BYTE_ADDR;
				rc = msm_camera_i2c_write(&i2c_client, 0x01,
					0x8B, MSM_CAMERA_I2C_BYTE_DATA);
			}
		}
		break;

	default:
		rc = -EFAULT;
		break;
	}
	return rc;
}

#endif
//FIH-SW-MM-MC-BringUpLM3642ForCameraFlashLed-00+}

static int msm_camera_flash_pwm(
	struct msm_camera_sensor_flash_pwm *pwm,
	unsigned led_state)
{
	int rc = 0;
	int PWM_PERIOD = USEC_PER_SEC / pwm->freq;

	static struct pwm_device *flash_pwm;

	if (!flash_pwm) {
		flash_pwm = pwm_request(pwm->channel, "camera-flash");
		if (flash_pwm == NULL || IS_ERR(flash_pwm)) {
			pr_err("%s: FAIL pwm_request(): flash_pwm=%p\n",
			       __func__, flash_pwm);
			flash_pwm = NULL;
			return -ENXIO;
		}
	}

	switch (led_state) {
	case MSM_CAMERA_LED_LOW:
		rc = pwm_config(flash_pwm,
			(PWM_PERIOD/pwm->max_load)*pwm->low_load,
			PWM_PERIOD);
		if (rc >= 0)
			rc = pwm_enable(flash_pwm);
		break;

	case MSM_CAMERA_LED_HIGH:
		rc = pwm_config(flash_pwm,
			(PWM_PERIOD/pwm->max_load)*pwm->high_load,
			PWM_PERIOD);
		if (rc >= 0)
			rc = pwm_enable(flash_pwm);
		break;

	case MSM_CAMERA_LED_OFF:
		pwm_disable(flash_pwm);
		break;
	case MSM_CAMERA_LED_INIT:
	case MSM_CAMERA_LED_RELEASE:
		break;

	default:
		rc = -EFAULT;
		break;
	}
	return rc;
}

int msm_camera_flash_pmic(
	struct msm_camera_sensor_flash_pmic *pmic,
	unsigned led_state)
{
	int rc = 0;

	switch (led_state) {
	case MSM_CAMERA_LED_OFF:
		rc = pmic->pmic_set_current(pmic->led_src_1, 0);
		if (pmic->num_of_src > 1)
			rc = pmic->pmic_set_current(pmic->led_src_2, 0);
		break;

	case MSM_CAMERA_LED_LOW:
		rc = pmic->pmic_set_current(pmic->led_src_1,
				pmic->low_current);
		if (pmic->num_of_src > 1)
			rc = pmic->pmic_set_current(pmic->led_src_2, 0);
		break;

	case MSM_CAMERA_LED_HIGH:
		rc = pmic->pmic_set_current(pmic->led_src_1,
			pmic->high_current);
		if (pmic->num_of_src > 1)
			rc = pmic->pmic_set_current(pmic->led_src_2,
				pmic->high_current);
		break;

	case MSM_CAMERA_LED_INIT:
	case MSM_CAMERA_LED_RELEASE:
		 break;

	default:
		rc = -EFAULT;
		break;
	}
	CDBG("flash_set_led_state: return %d\n", rc);

	return rc;
}

int32_t msm_camera_flash_set_led_state(
	struct msm_camera_sensor_flash_data *fdata, unsigned led_state)
{
	int32_t rc;

	if (fdata->flash_type != MSM_CAMERA_FLASH_LED ||
		fdata->flash_src == NULL)
		return -ENODEV;
    
	switch (fdata->flash_src->flash_sr_type) {
	case MSM_CAMERA_FLASH_SRC_PMIC:
		rc = msm_camera_flash_pmic(&fdata->flash_src->_fsrc.pmic_src,
			led_state);
		break;

	case MSM_CAMERA_FLASH_SRC_PWM:
		rc = msm_camera_flash_pwm(&fdata->flash_src->_fsrc.pwm_src,
			led_state);
		break;

	case MSM_CAMERA_FLASH_SRC_CURRENT_DRIVER:
		rc = msm_camera_flash_current_driver(
			&fdata->flash_src->_fsrc.current_driver_src,
			led_state);
		break;

	case MSM_CAMERA_FLASH_SRC_EXT:
		rc = msm_camera_flash_external(
			&fdata->flash_src->_fsrc.ext_driver_src,
			led_state);
		break;

	case MSM_CAMERA_FLASH_SRC_LED1:
		rc = msm_camera_flash_led(
				&fdata->flash_src->_fsrc.ext_driver_src,
				led_state);
		break;

	default:
		rc = -ENODEV;
		break;
	}
	return rc;
}

static int msm_strobe_flash_xenon_charge(int32_t flash_charge,
		int32_t charge_enable, uint32_t flash_recharge_duration)
{
	gpio_set_value_cansleep(flash_charge, charge_enable);
	if (charge_enable) {
		timer_flash.expires = jiffies +
			msecs_to_jiffies(flash_recharge_duration);
		/* add timer for the recharge */
		if (!timer_pending(&timer_flash))
			add_timer(&timer_flash);
	} else
		del_timer_sync(&timer_flash);
	return 0;
}

static void strobe_flash_xenon_recharge_handler(unsigned long data)
{
	unsigned long flags;
	struct msm_camera_sensor_strobe_flash_data *sfdata =
		(struct msm_camera_sensor_strobe_flash_data *)data;

	spin_lock_irqsave(&sfdata->timer_lock, flags);
	msm_strobe_flash_xenon_charge(sfdata->flash_charge, 1,
		sfdata->flash_recharge_duration);
	spin_unlock_irqrestore(&sfdata->timer_lock, flags);

	return;
}

static irqreturn_t strobe_flash_charge_ready_irq(int irq_num, void *data)
{
	struct msm_camera_sensor_strobe_flash_data *sfdata =
		(struct msm_camera_sensor_strobe_flash_data *)data;

	/* put the charge signal to low */
	gpio_set_value_cansleep(sfdata->flash_charge, 0);

	return IRQ_HANDLED;
}

static int msm_strobe_flash_xenon_init(
	struct msm_camera_sensor_strobe_flash_data *sfdata)
{
	unsigned long flags;
	int rc = 0;

	spin_lock_irqsave(&sfdata->spin_lock, flags);
	if (!sfdata->state) {

		rc = config_flash_gpio_table(MSM_CAM_FLASH_ON, sfdata);
		if (rc < 0) {
			pr_err("%s: gpio_request failed\n", __func__);
			goto go_out;
		}
		rc = request_irq(sfdata->irq, strobe_flash_charge_ready_irq,
			IRQF_TRIGGER_RISING, "charge_ready", sfdata);
		if (rc < 0) {
			pr_err("%s: request_irq failed %d\n", __func__, rc);
			goto go_out;
		}

		spin_lock_init(&sfdata->timer_lock);
		/* setup timer */
		init_timer(&timer_flash);
		timer_flash.function = strobe_flash_xenon_recharge_handler;
		timer_flash.data = (unsigned long)sfdata;
	}
	sfdata->state++;
go_out:
	spin_unlock_irqrestore(&sfdata->spin_lock, flags);

	return rc;
}

static int msm_strobe_flash_xenon_release
(struct msm_camera_sensor_strobe_flash_data *sfdata, int32_t final_release)
{
	unsigned long flags;

	spin_lock_irqsave(&sfdata->spin_lock, flags);
	if (sfdata->state > 0) {
		if (final_release)
			sfdata->state = 0;
		else
			sfdata->state--;

		if (!sfdata->state) {
			free_irq(sfdata->irq, sfdata);
			config_flash_gpio_table(MSM_CAM_FLASH_OFF, sfdata);
			if (timer_pending(&timer_flash))
				del_timer_sync(&timer_flash);
		}
	}
	spin_unlock_irqrestore(&sfdata->spin_lock, flags);
	return 0;
}

static void msm_strobe_flash_xenon_fn_init
	(struct msm_strobe_flash_ctrl *strobe_flash_ptr)
{
	strobe_flash_ptr->strobe_flash_init =
				msm_strobe_flash_xenon_init;
	strobe_flash_ptr->strobe_flash_charge =
				msm_strobe_flash_xenon_charge;
	strobe_flash_ptr->strobe_flash_release =
				msm_strobe_flash_xenon_release;
}

int msm_strobe_flash_init(struct msm_sync *sync, uint32_t sftype)
{
	int rc = 0;
	switch (sftype) {
	case MSM_CAMERA_STROBE_FLASH_XENON:
		if (sync->sdata->strobe_flash_data) {
			msm_strobe_flash_xenon_fn_init(&sync->sfctrl);
			rc = sync->sfctrl.strobe_flash_init(
			sync->sdata->strobe_flash_data);
		} else
			return -ENODEV;
		break;
	default:
		rc = -ENODEV;
	}
	return rc;
}

int msm_strobe_flash_ctrl(struct msm_camera_sensor_strobe_flash_data *sfdata,
	struct strobe_flash_ctrl_data *strobe_ctrl)
{
	int rc = 0;
	switch (strobe_ctrl->type) {
	case STROBE_FLASH_CTRL_INIT:
		if (!sfdata)
			return -ENODEV;
		rc = msm_strobe_flash_xenon_init(sfdata);
		break;
	case STROBE_FLASH_CTRL_CHARGE:
		rc = msm_strobe_flash_xenon_charge(sfdata->flash_charge,
			strobe_ctrl->charge_en,
			sfdata->flash_recharge_duration);
		break;
	case STROBE_FLASH_CTRL_RELEASE:
		if (sfdata)
			rc = msm_strobe_flash_xenon_release(sfdata, 0);
		break;
	default:
		pr_err("Invalid Strobe Flash State\n");
		rc = -EINVAL;
	}
	return rc;
}

int msm_flash_ctrl(struct msm_camera_sensor_info *sdata,
	struct flash_ctrl_data *flash_info)
{
	int rc = 0;
	sensor_data = sdata;
	switch (flash_info->flashtype) {
	case LED_FLASH:
		rc = msm_camera_flash_set_led_state(sdata->flash_data,
			flash_info->ctrl_data.led_state);
			break;
	case STROBE_FLASH:
		rc = msm_strobe_flash_ctrl(sdata->strobe_flash_data,
			&(flash_info->ctrl_data.strobe_ctrl));
		break;
	default:
		pr_err("Invalid Flash MODE\n");
		rc = -EINVAL;
	}
	return rc;
}
