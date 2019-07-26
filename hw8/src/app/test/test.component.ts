import { Component, OnInit } from '@angular/core';
import {trigger, transition, useAnimation, state, style} from '@angular/animations';
import {fadeInDown, fadeOutUp, slideOutRight, slideInLeft} from 'ng-animate';
@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.css'],
  animations: [
    trigger('fadeeffect', [
      state('normal', style({

        })),
      state('highlight', style({

      })),
      transition('void => *', useAnimation(slideInLeft, {
        // Set the duration to 5seconds and delay to 2seconds
        params: { timing: 0.2, delay: 0}
      })),
      // transition('* => void', useAnimation(slideOutRight, {
      //   // Set the duration to 5seconds and delay to 2seconds
      //   params: { timing: 2, delay: 0}
      // }))



      ])
  ]
})
export class TestComponent implements OnInit {
  state = 'normal';
  array = new Array();

  constructor() { }

  ngOnInit() {
  }
  animat() {
    if (this.state === 'normal') {
      this.state = 'highlight';

    } else {

      this.state = 'normal';
    }
  }
}
