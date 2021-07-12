using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TM.Data.Services;
using TM.Security.Services;
using TM.Configuration;
using Microsoft.AspNetCore.Http;
using System.Text;

namespace TM.Api
{
	public class Startup
	{
		private IServiceProvider ServiceProvider { get; set; }

		public IConfiguration Configuration { get; }

		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;
		}

		// This method gets called by the runtime. Use this method to add services to the container.
		public void ConfigureServices(IServiceCollection services)
		{
			services.AddControllers();

			services.AddSwaggerGen();

			services.AddTmConfiguration(Configuration);
			services.AddDataServices();
			services.AddSecurityServices();

			// Add Cross - origin resource sharing
			services.AddCors(options =>
			{
				options.AddPolicy("EnableCors", builder =>
				{
					builder.AllowAnyOrigin()
					.AllowAnyHeader()
					.AllowAnyMethod();
				});
			});

			var key = Encoding.UTF8.GetBytes(Configuration["SecuritySettings:JwtSecureKey"].ToString());

			services.AddAuthentication(x =>
			{
				x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
				x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
			}).AddJwtBearer(x => {
				x.TokenValidationParameters = new TokenValidationParameters
				{
					ValidateIssuer = false,
					ValidateAudience =false,
					ValidateLifetime = true,
					ValidateIssuerSigningKey = true,
					ValidIssuer = Configuration["SecuritySettings:JwtIssuer"].ToString(),
					ValidAudience = Configuration["SecuritySettings:JwtAudience"].ToString(),
					IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["SecuritySettings:JwtSecureKey"].ToString()))
				};
			});
		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{
			if (env.IsDevelopment())
			{
				app.UseDeveloperExceptionPage();
			}

			app.UseSwagger();
			// Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.), specifying the Swagger JSON endpoint.
			app.UseSwaggerUI(c =>
			{
				c.SwaggerEndpoint("/swagger/v1/swagger.json", "TM API V1");
				c.RoutePrefix = string.Empty;
			});

			app.UseHttpsRedirection();

			app.UseCookiePolicy();
			app.UseRouting();

			app.UseCors("EnableCors");

			app.UseAuthentication();

			app.UseAuthorization();

			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllers();
			});

			ServiceProvider = app.ApplicationServices;
			

		}
	}
}
