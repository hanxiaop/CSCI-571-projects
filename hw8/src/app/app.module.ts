import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import {FormsModule} from '@angular/forms';
import {RoundProgressModule} from 'angular-svg-round-progressbar';
import {MatTooltipModule} from '@angular/material/tooltip';
import { AppComponent } from './app.component';
import { SearchFormComponent } from './search-form/search-form.component';
import { NavigatorComponent } from './navigator/navigator.component';
import { ResultTableComponent } from './result-table/result-table.component';
import { FavoriteComponent } from './favorite/favorite.component';
import { DetailComponent } from './detail/detail.component';
import { EventsComponent } from './detail/events/events.component';
import { VenueComponent } from './detail/venue/venue.component';
import { ArtistComponent } from './detail/artist/artist.component';
import { UpcomingeventComponent } from './detail/upcomingevent/upcomingevent.component';
import {ShowPagesService} from './services/showPages.service';
import {AddFavoriteService} from './services/addFavorite.service';
import {ClitoServerService} from './services/clitoServer.service';
import {TransferDataService} from './services/transferData.service';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {MatButtonModule, MatCheckboxModule} from '@angular/material';
import {MatAutocompleteModule, MatInputModule, MatFormFieldModule} from '@angular/material';
import { AgmCoreModule} from '@agm/core';
import {ObservabService} from './services/observab.service';
import {EventEmitteService} from './services/eventEmitte.service';
import { TestComponent } from './test/test.component';
@NgModule({
  declarations: [
    AppComponent,
    SearchFormComponent,
    NavigatorComponent,
    ResultTableComponent,
    FavoriteComponent,
    DetailComponent,
    EventsComponent,
    VenueComponent,
    ArtistComponent,
    UpcomingeventComponent,
    TestComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    BrowserAnimationsModule,
    MatButtonModule,
    MatCheckboxModule,
    MatAutocompleteModule,
    MatInputModule,
    MatFormFieldModule,
    MatTooltipModule,
    RoundProgressModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyDz1cZyylt3u5Ty241_RuvKYzFqNdV6kKM'
    }),
  ],
  providers: [ShowPagesService, AddFavoriteService, ClitoServerService,
    TransferDataService, ObservabService, EventEmitteService],
  bootstrap: [AppComponent]
})
export class AppModule { }
