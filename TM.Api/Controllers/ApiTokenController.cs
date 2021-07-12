using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using TM.Data.Interface;
using TM.Models;

namespace TM.Api.Controllers
{
	/// <summary>
	/// End point for token operations.
	/// </summary>
	[Route("api/token")]
	public class ApiTokenController : ControllerBase
	{
		/// <summary>
		/// Token service instance through DI.
		/// </summary>
		private IApiTokenService ApiTokenService { get; }

		/// <summary>
		/// Initializes a new instance of token controller.
		/// </summary>
		/// <param name="apiTokenService">The token services through DI.</param>
		public ApiTokenController(IApiTokenService apiTokenService)
		{
			ApiTokenService = apiTokenService;
		}

		/// <summary>
		/// Disable a token.
		/// </summary>
		/// <param name="id">The token identifier.</param>
		[Authorize]
		[HttpPost]
		[Route("disable")]
		public async Task Disable([FromBody] int id)
		{
			await ApiTokenService.DisableTokenAsync(id);
		}

		/// <summary>
		/// Enable a token.
		/// </summary>
		/// <param name="id">The token identifier.</param>
		[Authorize]
		[HttpPost]
		[Route("enable")]
		public async Task Enable([FromBody] int id)
		{
			await ApiTokenService.EnableTokenAsync(id);
		}

		/// <summary>
		/// Generate a new token.
		/// </summary>
		/// <returns></returns>
		[HttpPost]
		[Route("generate")]
		public async Task<ApiToken> Generate()
		{
			return await ApiTokenService.GenerateTokenAsync();
		}

		/// <summary>
		/// Search token
		/// </summary>
		/// <param name="search">The search param.</param>
		/// <param name="pageNumber">The page number.</param>
		/// <returns>A list of paed tokens matching search param.</returns>
		[Authorize]
		[HttpGet]
		[Route("search")]
		public async Task<ApiTokenSearchResult> Search(string search, int? pageNumber)
		{
			return await ApiTokenService.SearchTokensAsync(search, pageNumber);
		}

		/// <summary>
		/// Validate a token
		/// </summary>
		/// <param name="token">The token.</param>
		/// <returns>A boolean value indicating if the token is valid.</returns>
		[HttpGet]
		[Route("validate/{token}")]
		[AllowAnonymous]
		public async Task<bool> Validate(string token)
		{
			return await ApiTokenService.ValidateAsync(token);
		}
	}
}
