import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UpcomingeventComponent } from './upcomingevent.component';

describe('UpcomingeventComponent', () => {
  let component: UpcomingeventComponent;
  let fixture: ComponentFixture<UpcomingeventComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UpcomingeventComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UpcomingeventComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
