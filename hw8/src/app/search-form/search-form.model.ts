export class SearchForm {
  public keyword: string;
  public category: string;
  public distance: string;
  public unit: string;
  public hereLocation: boolean;
  public locationValue: string;
  public hereLocationValue: string;

  constructor(keyword: string, category: string, distance: string,
              unit: string, hereLocation: boolean,
              locationValue: string, hereLocationValue: string) {
    this.keyword = keyword;
    this.category = category;
    this.distance = distance;
    this.unit = unit;
    this.hereLocation = hereLocation;
    this.locationValue = locationValue;
    this.hereLocationValue = hereLocationValue;
  }
}
