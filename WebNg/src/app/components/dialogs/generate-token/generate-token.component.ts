import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-generate-token',
  templateUrl: './generate-token.component.html',
  styleUrls: ['./generate-token.component.scss']
})
export class GenerateTokenComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: any,
          public dialogRef: MatDialogRef<GenerateTokenComponent>) { }

  ngOnInit(): void {
  }

  close() {
    this.dialogRef.close(false);
  }
}
