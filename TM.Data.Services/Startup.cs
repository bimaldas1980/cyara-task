using Microsoft.Extensions.DependencyInjection;
using TM.Data.Interface;

namespace TM.Data.Services
{
	public static class Startup
	{
		/// <summary>
		/// Adds the data services.
		/// </summary>
		/// <param name="services">The services.</param>
		/// <param name="configuration">The configuration.</param>
		public static void AddDataServices(this IServiceCollection services)
		{
			services.AddScoped<IUserService, UserService>();
			services.AddScoped<IApiTokenService, ApiTokenService>();
		}
	}
}
