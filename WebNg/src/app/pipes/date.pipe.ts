import { DatePipe } from "@angular/common";
import { Pipe, PipeTransform } from "@angular/core";

@Pipe({
	name: 'tmDate'
})
export class TmDatePipe implements PipeTransform {

	constructor (private datePipe: DatePipe) {
	}

	transform(value: any, args?: any): any {
		if (!value) {
			return '';
		}

		return this.datePipe.transform(value, 'dd/MM/yyyy');
	}

}
