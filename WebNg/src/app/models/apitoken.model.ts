
export interface IApiToken {
   	id: number;
    token: string;
	startDate: Date;
	endDate: Date;
	createdAt: Date;
	modifiedAt: Date;
	createdBy: string;
	modifiedBy: string;
	isDisabled: boolean;
	isEnded: boolean;
}

