import { mediaquery } from '@kit.ArkUI';

export enum BreakpointTypeEnum {
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
}

export interface BreakpointTypes<T> {
  sm: T;
  md: T;
  lg: T;
}

export class BreakpointType<T> {
  sm: T;
  md: T;
  lg: T;

  constructor(param: BreakpointTypes<T>) {
    this.sm = param.sm;
    this.md = param.md;
    this.lg = param.lg;
  }

  getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === BreakpointTypeEnum.SM) {
      return this.sm;
    }
    if (currentBreakpoint === BreakpointTypeEnum.MD) {
      return this.md;
    }
    return this.lg;
  }
}

export class BreakpointSystem {
  private currentBreakpoint: string = BreakpointTypeEnum.MD;
  private smListener: mediaquery.MediaQueryListener | undefined;
  private mdListener: mediaquery.MediaQueryListener | undefined;
  private lgListener: mediaquery.MediaQueryListener | undefined;

  private updateCurrentBreakpoint(breakpoint: BreakpointTypeEnum) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.set<string>('currentBreakpoint', this.currentBreakpoint);
    }
  }

  private isBreakpointSM = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.SM);
    }
  }
  private isBreakpointMD = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.MD);
    }
  }
  private isBreakpointLG = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.LG);
    }
  }

  public register() {
    this.smListener = mediaquery.matchMediaSync("(320vp<width<600vp)");
    if (this.smListener?.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.SM);
    }
    this.smListener?.on("change", this.isBreakpointSM);
    this.mdListener = mediaquery.matchMediaSync("(600vp<=width<840vp)");
    if (this.mdListener?.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.MD);
    }
    this.mdListener?.on("change", this.isBreakpointMD);
    this.lgListener = mediaquery.matchMediaSync("(840vp<=width)");
    if (this.lgListener?.matches) {
      this.updateCurrentBreakpoint(BreakpointTypeEnum.LG);
    }
    this.lgListener?.on("change", this.isBreakpointLG);
  }

  public unregister() {
    this.smListener?.off("change", this.isBreakpointSM);
    this.mdListener?.off("change", this.isBreakpointMD);
    this.lgListener?.off("change", this.isBreakpointLG);
  }
}