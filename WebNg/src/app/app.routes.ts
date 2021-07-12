import { Routes } from "@angular/router";
import { HomeComponent } from "./components/home/home.component";
import { LoginComponent } from "./components/login/login.component";
import { AuthGuard } from "./services/security/auth-guard.service";

export const routes: Routes = [
	{
		path: '',
		redirectTo: 'home',
		pathMatch: 'full'
	},
	{
		path: 'login',
		data: { title: 'IHT Login' },
        component: LoginComponent
    },
    {
		path: 'home',
		component: HomeComponent,
		canActivate: [AuthGuard],
		data: { title: 'Home' }
	},
    {
		path: '**',
		redirectTo: 'home'
	}];

    export const appRoutingProviders: any[] = [];