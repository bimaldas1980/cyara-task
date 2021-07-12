import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';



@Component({
  selector: 'app-confirm-disable',
  templateUrl: './confirm-disable.component.html',
  styleUrls: ['./confirm-disable.component.scss']
})
export class ConfirmDisableComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<ConfirmDisableComponent>) { }

  ngOnInit(): void {
  }

  confirm() {
    this.dialogRef.close(true);
  }

  cancel() {
    this.dialogRef.close(false);
  }

}
