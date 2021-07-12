import { SecurityService } from './../../services/security/security.service';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  
  loginForm = this.formBuilder.group({
		username: [null, [Validators.required]],
		password: [null, [Validators.required]]
	});

  loginError = false;

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
	  private securityService: SecurityService) { }

  ngOnInit(): void {
      this.loginError = false;
  }

  login() {
    
    if(!this.loginForm.valid) {
      return;
    }

    this.loginError = false;

    const loginFormValues = this.loginForm.getRawValue();

    this.securityService.authenticate(loginFormValues.username, loginFormValues.password)
    .subscribe(res => {
        if (res) {
          this.securityService.setToken(res);
          this.router.navigate(['home']);
        }
    },
    err => {
      this.loginError = true;
    });
	}
}
