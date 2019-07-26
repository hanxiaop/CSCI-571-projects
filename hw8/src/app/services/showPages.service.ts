import {EventEmitter} from '@angular/core';

export class ShowPagesService {

  detailAndListButton = new EventEmitter<string>();

  searchFormToResult = new EventEmitter<string>();

  listToDetailPage = new EventEmitter<any>();
  //changeBacktoShowPage = new EventEmitter<string>();
  constructor () {}





}
