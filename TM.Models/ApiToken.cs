using System;

namespace TM.Models
{
	/// <summary>
	/// The API Token model.
	/// </summary>
	public class ApiToken
	{
		/// <summary>
		/// The unique idnetifier.
		/// </summary>
		public int Id { get; set; }

		/// <summary>
		/// The API token.
		/// </summary>
		public string Token { get; set; }

		/// <summary>
		/// The start date of the token.
		/// </summary>
		public DateTime StartDate { get; set; }

		/// <summary>
		/// The end date of the token.
		/// </summary>
		public DateTime EndDate { get; set; }

		/// <summary>
		/// The token created date.
		/// </summary>
		public DateTime CreatedAt { get; set; }

		/// <summary>
		/// The token last modified date.
		/// </summary>
		public DateTime? ModifiedAt { get; set; }

		/// <summary>
		/// The token created user.
		/// </summary>
		public string CreatedBy { get; set; }

		/// <summary>
		/// The token last modified user.
		/// </summary>
		public string ModifiedBy { get; set; }

		public bool IsDisabled { get; set; }

		/// <summary>
		/// Boolean value to indicate if a token is ended.
		/// </summary>
		public bool IsEnded 
		{
			get
			{
				return this.EndDate < DateTime.Now;
			}	
		}

	}
}
