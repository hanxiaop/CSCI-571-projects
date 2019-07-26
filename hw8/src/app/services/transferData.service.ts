import {EventEmitter} from '@angular/core';

export class TransferDataService {

  searchFormToList = new EventEmitter<string>();

  // searchFormToResult = new EventEmitter<string>();

  listTableToEvent = new EventEmitter();

  listTableToArtistSPO = new EventEmitter();
  listTableToArtisGoogle = new EventEmitter();
  listTableToArtisName = new EventEmitter();


  listTableToVene = new EventEmitter();
  listTableToUpcoming = new EventEmitter();


  constructor () {}





}
