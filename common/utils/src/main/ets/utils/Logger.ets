import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger {
  private domain: number;
  private prefix: string;
  private format: string = "%{public}s, %{public}s";

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  debug(...args: Object[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: Object[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: Object[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: Object[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
}

export default new Logger('[HMOSWorld]');
