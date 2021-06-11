public class JsonToApex{
		public list<results> results{get;set;}
		public String status{get;set;}
		public list<String> html_attributions{get;set;}
	public class viewport{
		public southwest southwest{get;set;}
		public northeast northeast{get;set;}
	}
	public class southwest{
		public Decimal lng{get;set;}
		public Decimal lat{get;set;}
	}
	public class results{
		public String place_id{get;set;}
		public plus_code plus_code{get;set;}
		public Integer price_level{get;set;}
		public Integer rating{get;set;}
		public list<photos> photos{get;set;}
		public String reference{get;set;}
		public opening_hours opening_hours{get;set;}
		public String scope{get;set;}
		public String name{get;set;}
		public list<String> types{get;set;}
		public String id{get;set;}
		public Integer user_ratings_total{get;set;}
		public String icon{get;set;}
		public String vicinity{get;set;}
		public geometry geometry{get;set;}
	}
	public class plus_code{
		public String global_code{get;set;}
		public String compound_code{get;set;}
	}
	public class photos{
		public Integer height{get;set;}
		public String photo_reference{get;set;}
		public Integer width{get;set;}
		public list<String> html_attributions{get;set;}
	}
	public class opening_hours{
		public Boolean open_now{get;set;}
	}
	public class northeast{
		public Decimal lat{get;set;}
		public Decimal lng{get;set;}
	}
	public class location{
		public Decimal lng{get;set;}
		public Decimal lat{get;set;}
	}
	public class geometry{
		public viewport viewport{get;set;}
		public location location{get;set;}
	}
}