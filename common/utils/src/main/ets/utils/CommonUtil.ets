/**
 * Public tool class.
 */
export class CommonUtil {
  /**
   * Replace count with text when the count number exceeds the maximum value.
   * @param count
   * @param max
   * @param replaceText
   */
  public static formatNumToMaxText(count: number, max: number, replaceText: string): string {
    return count > max ? max + replaceText : (count ?? 0).toString();
  }

  /**
   * Replace count with plus sign when the count number over one thousand
   * @param count
   */
  public static transNumberOverOneThousand(count: number): string {
    return CommonUtil.formatNumToMaxText(count, 999, '+');
  }
}