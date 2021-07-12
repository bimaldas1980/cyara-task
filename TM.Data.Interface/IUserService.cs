using System.Threading.Tasks;
using TM.Models;

namespace TM.Data.Interface
{
	/// <summary>
	/// The user services.
	/// </summary>
	public interface IUserService
	{
		/// <summary>
		/// API to get the user by username.
		/// </summary>
		/// <param name="username">The username</param>
		/// <returns></returns>
		Task<TmUser> GetUserByUsernameAsync(string username);

		/// <summary>
		/// Authenticate the user.
		/// </summary>
		/// <param name="username">The username.</param>
		/// <param name="password">The password.</param>
		/// <returns></returns>
		Task<TmUser> AuthenticateAsync(string username, string password);
	}
}
