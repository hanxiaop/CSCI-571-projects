
export class EventsModel {
  public name: string;
  public uri: string;
  public artist: string;
  public date: string;
  public time: string;
  public type: string;
  public comparedate: string;

  constructor(name: string, uri: string, artist: string, date: string,
              time: string, type: string, comparedate: string) {
    this.name = name;
    this.uri = uri;
    this.artist = artist;
    this.time = time;
    this.date = date;
    this.type = type;
    this.comparedate = comparedate;

  }
}
