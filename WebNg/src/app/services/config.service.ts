import { Injectable } from "@angular/core";

/*
    Ideally this should come from server configuration file. Hard-coding it here. Will update if I find time.
*/
@Injectable()
export class ConfigService {

    constructor() {
    }

    getApiRootPath() {
        return 'https://localhost:44362/api/';
    }

    angularRootPath() {
        return 'https://localhost:4200'
    }

}