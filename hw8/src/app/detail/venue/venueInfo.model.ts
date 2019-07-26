
export class VenueInfoModel {
  public name: string;
  public address: string;
  public city: string;
  public phoneNumber: string;
  public openhours: string;
  public generalRule: string;
  public childRukle: string;


  constructor(name: string, address: string, city:string, phoneNumber: string,
              openhours: string, generalRule: string, childRukle: string) {
    this.name = name;
    this.address = address;
    this.phoneNumber = phoneNumber;
    this.city =city;
    this.openhours = openhours;
    this.generalRule = generalRule;
    this.childRukle = childRukle;

  }
}
