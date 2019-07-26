


export class ASingleEventModel {
  public date: string;
  public event: string;
  public category: string;
  public eventLong: string;
  public venue: string;
  public favorite: boolean;

  public favoCheck: string;
  constructor(date: string, event: string, category: string,
              venue: string, favorite: boolean) {
    this.date = date;
    this.eventLong = event;
    this.category = category;
    this.venue = venue;
    this.favorite = favorite;
  }
}
