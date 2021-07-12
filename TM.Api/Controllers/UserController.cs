using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using TM.Data.Interface;
using TM.Models;

namespace TM.Api.Controllers
{
	/// <summary>
	/// End point for user operations.
	/// </summary>
	[Route("api/user")]
	[ApiController]
	[Authorize]
	public class UserController : ControllerBase
	{
		/// <summary>
		/// The user service instance through DI.
		/// </summary>
		private IUserService UserService { get; }

		/// <summary>
		/// Initializes a new instance of user controller.
		/// </summary>
		/// <param name="userServices">The user services through DI.</param>
		public UserController(IUserService userServices)
		{
			UserService = userServices;
		}

		/// <summary>
		/// Gets a user by username.
		/// </summary>
		/// <param name="username">The username</param>
		/// <returns></returns>
		[HttpGet]
		[Route("{username}")]
		public async Task<TmUser> GetUserByUsernameAsync(string username)
		{
			return await UserService.GetUserByUsernameAsync(username);
		}
	}
}
