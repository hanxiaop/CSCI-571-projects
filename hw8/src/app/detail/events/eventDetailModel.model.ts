
export class EventDetailModelModel {
  public artist: any;
  public venue: string;
  public time: string;
  public category: any;
  public priceRange: string;
  public ticketStatus: string;
  public byTicket: string;
  public seatMap: string;

  constructor(artist: any, venue: string, time: string,
              category: any, priceRange: string, ticketStatus: string, byTicket:string, seatMap:string) {
    this.artist = artist;
    this.venue = time;
    this.time = category;
    this.priceRange = priceRange;
    this.category = category;
    this.ticketStatus = ticketStatus;
    this.byTicket = byTicket;
    this.seatMap = seatMap;

  }
}
