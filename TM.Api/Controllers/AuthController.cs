using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;
using TM.Models;
using TM.Configuration;
using TM.Security.Interface;
using System.Security.Claims;

namespace TM.Api.Controllers
{
	/// <summary>
	/// End point for Auth related actions.
	/// </summary>
	[Route("api/auth")]
	[ApiController]
	[AllowAnonymous]
	public class AuthController : ControllerBase
	{
		/// <summary>
		/// Instance of security service through DI
		/// </summary>
		private ISecurityService SecurityService { get; set; }

		/// <summary>
		/// Instance of configuration through DI
		/// </summary>
		private ITmConfiguration TmConfiguration { get; set; }

		/// <summary>
		/// Initialize an auth controller instance.
		/// </summary>
		/// <param name="securityService">The security service instance through DI.</param>
		/// <param name="configuration">The configuration through DI.</param>
		public AuthController(
			ISecurityService securityService,
			ITmConfiguration configuration)
		{
			SecurityService = securityService;
			TmConfiguration = configuration;
		}

		/// <summary>
		/// The end point to authenticate a user.
		/// </summary>
		/// <param name="authModel">The authentication model.</param>
		/// <returns>A JWT with auth info.</returns>
		[HttpPost]
		[Route("login")]
		public async Task<IActionResult> Authenticate([FromBody] AuthModel authModel)
		{
			if (authModel == null 
				|| string.IsNullOrWhiteSpace(authModel.Username) 
				|| string.IsNullOrWhiteSpace(authModel.Password))
			{
				return BadRequest();
			}

			var token = await SecurityService.AuthenticateAsync(authModel);

			if (string.IsNullOrWhiteSpace(token))
			{
				return BadRequest();
			}

			return Ok(new { Token = token });
		}

		/// <summary>
		/// Logout a user and expire session.
		/// </summary>
		/// <returns></returns>
		[Route("logout")]
		[HttpPost]
		public async Task<IActionResult> LogoutAsync()
		{
			var authProperties = new AuthenticationProperties
			{
				ExpiresUtc = DateTimeOffset.Now
			};

			await HttpContext.SignOutAsync(
				CookieAuthenticationDefaults.AuthenticationScheme,
				authProperties);

			return new JsonResult(true);
		}
	}
}
