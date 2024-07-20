import vibrator from '@ohos.vibrator';
import { BusinessError } from '@ohos.base';

export function normalVibrateFeedback(){
  try {
    // 查询是否支持'haptic.clock.timer'
    vibrator.isSupportEffect('haptic.clock.timer', (err: BusinessError, state: boolean) => {
      if (err) {
        console.error(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
        return;
      }
      console.info('Succeed in querying effect');
      if (state) {
        try {
          // 触发马达振动
          vibrator.startVibration({
            type: 'preset',
            effectId: 'haptic.clock.timer',
            count: 1,
          }, {
            usage: 'unknown'
          }, (error: BusinessError) => {
            if (error) {
              console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            } else {
              console.info('Succeed in starting vibration');
            }
          });
        } catch (error) {
          let e: BusinessError = error as BusinessError;
          console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
        }
      }
    })
  } catch (error) {
    let e: BusinessError = error as BusinessError;
    console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
  }
}
