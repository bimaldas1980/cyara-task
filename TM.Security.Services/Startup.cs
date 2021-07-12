using Microsoft.Extensions.DependencyInjection;
using TM.Security.Interface;

namespace TM.Security.Services
{
	public static class Startup
	{
		/// <summary>
		/// Adds the security services.
		/// </summary>
		/// <param name="services">The services.</param>
		/// <param name="configuration">The configuration.</param>
		public static void AddSecurityServices(this IServiceCollection services)
		{
			services.AddScoped<ISecurityService, SecurityService>();
		}
	}
}
