using System.Threading.Tasks;
using TM.Models;
using System.Security.Claims;
using System.Collections.Generic;

namespace TM.Security.Interface
{
	/// <summary>
	/// Authentication/Authorization related API.
	/// </summary>
	public interface ISecurityService
	{
		/// <summary>
		/// Authenticate a user and set server session.
		/// </summary>
		/// <param name="authModel">The authentication model.</param>
		/// <returns></returns>
		Task<string> AuthenticateAsync(AuthModel authModel);
	}
}
