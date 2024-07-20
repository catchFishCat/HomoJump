import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  showHelpDialog(){
    promptAction.showDialog({
      message:`
      当前提供设备-设置中的扩展服务管理页的开关按钮来开启/关闭选择的无障碍扩展服务：

1、打开设备设置页面，进入“辅助功能”，“扩展服务”小标题下的“已安装的服务”显示当前安装的扩展服务个数，点击进入，展示安装的扩展服务列表；未安装扩展服务时，“已安装的扩展服务”不可点击，并显示“无服务”。

2、选择需要开启/关闭的扩展服务，通过开关按钮进行扩展服务的开启/关闭。

3、开启时，弹出安全提醒，在倒计时结束后，勾选“我已知晓如上风险，并自愿承担可能导致的后果。”后，可选择“开启”/“不开启”按钮； 关闭时，将开启的开关关闭，即可关闭已开启的扩展服务。

4、在“无障碍快捷方式”中，选择本应用，快速三次按电源键，即可激活无障碍服务。
      `
    })
  }

  build() {

    Column(){
      Row(){
        Text('HomoJump')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
      }
      .margin({top:20})
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('应用')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#15232e')
        Text('󰄀')
          .fontSize(28)
          .fontWeight(FontWeight.Medium)
          .fontColor('#919494')
          .onClick(()=>{
            this.showHelpDialog()
          })
      }
      .margin({top:20,bottom:20})
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      List({space:15}){
        ListItem(){AppItem({logo:$r('app.media.mcdonald'),appName:'麦当劳'})}
        ListItem(){AppItem({logo:$r('app.media.kfc'),appName:'肯德基'})}
        ListItem(){AppItem({logo:$r('app.media.luckin_coffee'),appName:'瑞幸咖啡'})}
        ListItem(){AppItem({logo:$r('app.media.bilibili'),appName:'哔哩哔哩'})}
        ListItem(){AppItem({logo:$r('app.media.alipay'),appName:'支付宝'})}
      }
      .layoutWeight(1)
      .lanes({minLength:300,maxLength:600},15)
    }
    .padding({left:20,right:20})
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f3f5')

  }
}

@Preview
@Component
struct AppItem {
  logo:ResourceStr = $r('app.media.mcdonald')
  appName:ResourceStr = '麦当劳'
  isOn:boolean = true
  build() {
    Row(){
      Row(){
        Image(this.logo)
          .width(50)
          .height(50)
        Text(this.appName)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .padding({left:10,top:5})
          .fontColor(Color.Black)
      }
      .alignItems(VerticalAlign.Top)
      Toggle({type:ToggleType.Switch,isOn:this.isOn})
        .margin({right:10})

    }
    .width('100%')
    .padding(10)
    .borderRadius(20)
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceBetween)

  }
}