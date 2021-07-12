import { Injectable } from "@angular/core";
import { CanActivate, Router } from "@angular/router";
import { JwtHelperService } from "@auth0/angular-jwt";
import { SecurityService } from "./security.service";

@Injectable({
	providedIn: 'root'
})
export class AuthGuard implements CanActivate {
    constructor (
		private router: Router,
		private jwtHelper: JwtHelperService,
		private securityService: SecurityService
	) {
	}

	canActivate() {
		const token = this.securityService.getToken();		

		if (token && !this.jwtHelper.isTokenExpired(token)) {
				return true;
		}

		this.router.navigate(['login']);
		return false;
	}
}