import { ConfirmDisableComponent } from './../components/dialogs/confirm-disable/confirm-disable.component';
import { GenerateTokenComponent } from './../components/dialogs/generate-token/generate-token.component';
import { Injectable } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { Router } from "@angular/router";
import { Observable } from "rxjs";

@Injectable()
export class DialogService {
    constructor (
		private dialog: MatDialog,
		private router: Router) {
	}

    createDialog(data: any, component: any, width: string = '60%'): Observable<any> {

		const dialogRef = this.dialog.open(component, {
			width,
			data,
			position: { top: '50px' }
		});

		return dialogRef.afterClosed();
	}

    generateTokenDialog(token: string) {
        const data = { token };
        return this.createDialog(data, GenerateTokenComponent);
    }

    diableTokenConfirmDialog(id: number, token: string) {
            const data = {
                    id,
                    token
            };

            return this.createDialog(data, ConfirmDisableComponent);
    }
}