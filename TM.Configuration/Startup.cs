using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace TM.Configuration
{
	public static class Startup
	{
		/// <summary>
		/// Adds the configuration.
		/// </summary>
		/// <param name="services">The services.</param>
		/// <param name="configuration">The configuration.</param>
		public static void AddTmConfiguration(this IServiceCollection services, IConfiguration configuration)
		{
			// Allow us to access strongly typed config data
			services.AddOptions();
			services.Configure<Models.ConnectionStrings>(options => configuration.GetSection("ConnectionStrings").Bind(options));
			services.Configure<Models.SecuritySettings>(options => configuration.GetSection("SecuritySettings").Bind(options));
			services.Configure<Models.ApplicationSettings>(options => configuration.GetSection("ApplicationSettings").Bind(options));
			services.AddScoped<ITmConfiguration, TmConfiguration>();
		}
	}
}
