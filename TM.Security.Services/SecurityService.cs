using System;
using TM.Configuration;
using TM.Models;
using TM.Security.Interface;
using TM.Data.Interface;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace TM.Security.Services
{
	/// <inheritdoc />
	public class SecurityService: ISecurityService
	{
		/// <summary>
		/// The user service through DI.
		/// </summary>
		private IUserService UserService { get; }

		/// <summary>
		/// The system configuration through DI.
		/// </summary>
		private ITmConfiguration TmConfiguration { get; }

		/// <inheritdoc />
		public SecurityService(
			IUserService userService,
			ITmConfiguration configuration
			)
		{
			UserService = userService;
			TmConfiguration = configuration;
		}

		/// <inheritdoc />
		public async Task<string> AuthenticateAsync(AuthModel authModel)
		{
			var authUser = await UserService.AuthenticateAsync(authModel.Username, authModel.Password);

			if (authUser == null)
			{
				return string.Empty;
			}

			var claims = new Claim[]
					{
						new Claim(JwtRegisteredClaimNames.Sub, authUser.Id.ToString()),
						new Claim("name", authUser.Username),
						new Claim("givenname", authUser.GivenNames),
						new Claim("familyname", authUser.FamilyName)
					};

			var signingCredentials = new SigningCredentials(
				new SymmetricSecurityKey(Encoding.UTF8.GetBytes(TmConfiguration.SecuritySettings.JwtSecureKey)), 
				SecurityAlgorithms.HmacSha256);	

			var tokenOptions = new JwtSecurityToken
			(
				issuer: TmConfiguration.SecuritySettings.JwtIssuer,
				audience: TmConfiguration.SecuritySettings.JwtAudience,
				claims: claims,
				expires: DateTime.Now.AddMinutes(TmConfiguration.SecuritySettings.JwtLifetime),
				signingCredentials: signingCredentials
			);
			var token = new JwtSecurityTokenHandler().WriteToken(tokenOptions); 

			return token;
		}
	}
}
