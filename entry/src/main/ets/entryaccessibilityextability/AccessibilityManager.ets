import {
  AccessibilityElement,
  AccessibilityEvent,
  AccessibilityExtensionContext,
  ElementAttributeKeys
} from '@ohos.application.AccessibilityExtensionAbility';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';
import { accessibility } from '@kit.AccessibilityKit';
import { HashSet } from '@kit.ArkTS';

interface Rect {
  left: number,
  top: number,
  width: number,
  height: number,
}

// 想要查询的属性信息
let wantedAttribute: ElementAttributeKeys[] = ['bundleName', 'text', 'description', 'windowId','componentId'];
type attributeValues = string | number | boolean | AccessibilityElement | AccessibilityElement[] | string[] | Rect;

export default class AccessibilityManager {
  private static instance: AccessibilityManager;
  accessibleContext?: AccessibilityExtensionContext;
  currentPageElementArray: Array<AccessibilityElement> | null = null;
  searching:boolean = false;
  appSet:HashSet<string> =  new HashSet()

  static getInstance(): AccessibilityManager {
    if (!AccessibilityManager.instance) {
      AccessibilityManager.instance = new AccessibilityManager();
    }
    return AccessibilityManager.instance;
  }

  onStart(context: AccessibilityExtensionContext) {
    console.info(`AccessibilityManager onStart`);
    this.accessibleContext = context;
    this.appSet.add('com.mcdonalds.cma.hm')//麦当劳
    this.appSet.add('com.yumc.kfc.superapp')//肯德基
    this.appSet.add('com.lucky.luckincoffee')//瑞幸咖啡
    this.appSet.add('yylx.danmaku.bili')//哔哩哔哩
  }

  onStop() {
    console.info(`AccessibilityManager onStop`);
    this.accessibleContext = undefined;
  }

  async onEvent(accessibilityEvent: AccessibilityEvent): Promise<void> {
    const element = accessibilityEvent.target
    if(!element) return
    const bundleName = await this.getAttributeValue(element, 'bundleName') as string
    if(!bundleName) return
    if(!this.appSet.has(bundleName)) return

    await this.getCurrentPageAllElement();
    await this.printAllElementInfo();

    // console.info(`AccessibilityManager onEvent`);

    // switch (accessibilityEvent.eventType) {
    //   case 'rightThenDown':
    //   // 获取当前页面的所有节点
    //     this.getCurrentPageAllElement();
    //     break;
    //   case 'leftThenDown':
    //   // 打印所有节点，如遇到跳过则点击
    //     this.printAllElementInfo();
    //     break;
    //   default:
    //     break;
    // }
  }

  async findAndJump() {
    //

  }

  async getCurrentPageAllElement(): Promise<void> {
    console.info(`AccessibilityManager getCurrentPageAllElement`);
    let rootElement: AccessibilityElement;
    if (!this.accessibleContext) {
      console.error(`AccessibilityManager accessibleContext undefined`);
      return;
    }
    if(this.searching)
      return
    try {
      this.searching = true
      rootElement = await this.accessibleContext?.getWindowRootElement();
      this.currentPageElementArray = []
      await this.getChildren(rootElement)
      this.searching = false
    } catch (error) {
      console.error(`AccessibilityExtAbility Failed to getWindowRootElement. Cause:${JSON.stringify(error)}`);
      this.searching = false
    }
  }

  async getElementWantedInfo(accessibilityElement: AccessibilityElement, wantedAttribute: ElementAttributeKeys[]):
    Promise<string | null> {
    // console.info(`AccessibilityUtils getElementAllInfo`);
    if (accessibilityElement === null) {
      console.error(`AccessibilityUtils accessibilityElement is null`);
      return null;
    }

    let info = '';
    let value: attributeValues | null;
    for (let name of wantedAttribute) {
      value = await this.getAttributeValue(accessibilityElement, name);
      info = info.concat(name + ': ' + value + ' ');
    }
    return info;
  }

  async getChildren(element: AccessibilityElement) {
    const children = (await this.getAttributeValue(element, 'children')) as AccessibilityElement[]

    if (!this.currentPageElementArray)
      return

    this.currentPageElementArray.push(...children)

    for (let i = 0; i < children.length; i++)
      await this.getChildren(children[i])


  }

  async getAttributeValue(accessibilityElement: AccessibilityElement, key: ElementAttributeKeys):
    Promise<attributeValues | null> {
    // console.info(`AccessibilityUtils getAttributeValue`);
    let value: attributeValues;
    let keys = await accessibilityElement.attributeNames();
    let isExit = false;
    for (let keyString of keys) {
      if (key == keyString) {
        isExit = true;
      }
    }
    if (isExit) {
      try {
        value = await accessibilityElement.attributeValue(key);
        return value;
      } catch (error) {
        console.error(`AccessibilityUtils Failed to get attributeValue of ${key} . Cause:  ${JSON.stringify(error)}`);
      }
    }
    return null;
  }

  async printAllElementInfo(): Promise<void> {
    console.info(`AccessibilityManager printAllElementInfo,length:${this.currentPageElementArray?.length}}`);
    if (this.currentPageElementArray === null || this.currentPageElementArray.length === 0) {
      console.error(`AccessibilityManager currentPageElementArray is null`);
      return;
    }
    let info: string | null = null;
    for (let index = 0; index < this.currentPageElementArray.length; index++) {
      const element = this.currentPageElementArray[index]
      info = await this.getElementWantedInfo(element, wantedAttribute);
      const text = (await this.getAttributeValue(element, 'text')) as string
      const bundleName = (await this.getAttributeValue(element, 'bundleName')) as string
      if (text.includes('跳过')) {
        element.performAction('click')
        console.info('发现ElementInfo包含跳过，已点击')
      }
      if (text.includes('我知道了')) {
        element.performAction('click')
        console.info('发现ElementInfo包含我知道了，已点击')
      }
      console.info(`AccessibilityManager printElementInfo${info}`);
    }
  }
}