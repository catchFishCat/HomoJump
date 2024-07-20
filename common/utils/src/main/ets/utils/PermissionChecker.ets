import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit'

export class PermissionChecker{
  context:Context
  constructor(context:Context) {
    this.context = context
  }
  async checkPermission(permission:Permissions,permissionName:string,reason:string){
    const manager = abilityAccessCtrl.createAtManager()
    await manager.requestPermissionsFromUser(this.context, [permission])
    const buildInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const status = await manager.checkAccessToken(buildInfo.appInfo?.accessTokenId, permission)
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      //被拒绝，弹出申请框，跳转到设置
      AlertDialog.show(
        {
          title: `${permissionName}权限申请`,
          message: reason,
          autoCancel: true,
          alignment: DialogAlignment.Center,
          gridCount: 4,
          offset: { dx: 0, dy: -20 },
          primaryButton: {
            value: '取消',
            action: () => {
            },
            fontColor:Color.Blue
          },
          secondaryButton: {
            enabled: true,
            defaultFocus: true,
            style: DialogButtonStyle.HIGHLIGHT,
            value: '去设置',
            action: () => {
              (this.context as common.UIAbilityContext).startAbility({
                bundleName: 'com.huawei.hmos.settings',
                abilityName: 'com.huawei.hmos.settings.MainAbility',
                uri: "application_info_entry",
                parameters: {
                  pushParams: buildInfo.name
                }
              })
            },
            backgroundColor:Color.Blue
          },
          showInSubWindow:true,
        })
      return false
    }else{
      return true
    }
  }
}