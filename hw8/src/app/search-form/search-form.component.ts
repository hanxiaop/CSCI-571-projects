import { Component, OnInit } from '@angular/core';
import {SearchForm} from './search-form.model';
import {ClitoServerService} from '../services/clitoServer.service';
import {NgForm} from '@angular/forms';
import {FormControl} from '@angular/forms';
import {ShowPagesService} from '../services/showPages.service';
import {TransferDataService} from '../services/transferData.service';
import {ObservabService} from '../services/observab.service';
import {EventEmitteService} from '../services/eventEmitte.service';
@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent implements OnInit {

  searchForm: SearchForm = new SearchForm('', 'All', null, 'Miles', true, '', '');
  needLocationType = false;
  original = '111';
  hereLocationV: string[];
  options: any;
  requestAuto: any;
  tempArray = new Array();
  constructor(private cliToserver: ClitoServerService, private showPage: ShowPagesService,
              private transferData: TransferDataService, private eventEmit: EventEmitteService,
              private observBale: ObservabService) { }

  ngOnInit() {
    //localStorage.clear();
    this.hereLocation();
  }

  radioButCheck(vall: number) {
    this.needLocationType = (vall === 2);
    this.original = '222';
  }
  hereLocation() {
    this.cliToserver.getLocation().subscribe(response => {
      this.hereLocationV = [response['lat'], response['lon']];
    });
  }

  onInputChanged(searchStr: string): void {
    this.options = [];

    if (this.requestAuto) {
      this.requestAuto.unsubscribe();
    }
    this.requestAuto = this.cliToserver.sendRequest(searchStr).subscribe((result) => {
      if (result) {
        for (let nam of result._embedded.attractions) {
          this.tempArray.push(nam.name);
        }
        this.options = this.tempArray;
        this.tempArray = new Array();

      }
    });
  }

  submitForm(form: NgForm) {
    this.showPage.searchFormToResult.emit('showPage');
    if (this.searchForm.distance === null || this.searchForm.distance === '') {
      this.searchForm.distance = '10';
    }
    if (this.searchForm.hereLocation === true) {
      this.searchForm.hereLocationValue = this.hereLocationV[0] + ',' + this.hereLocationV[1];
    }

    this.cliToserver.sendRequestSearchEvent(this.searchForm).subscribe(
      data => {
        // this.returnedEventJson.emit(data);
        this.transferData.searchFormToList.emit(data);

      }

    );
  }
  resetFormInfo(form: NgForm) {
    this.searchForm = new SearchForm('', 'All', null, 'Miles', true, '', '');
    //this.hereLocation();
    form.resetForm({category: 'All', units: 'Miles', distance: null, location: true, typedLocation: ''});
    console.log(this.searchForm);
    this.original = '111';
    this.eventEmit.changeDetailEvent.emit('clear');
  }


}
