namespace Microsoft.Office.Server.Search.Administration
{ 
    public enum SearchObjectLevel {
        SPWeb,
        SPSite
        SPSiteSubscription,
        Ssa
    }

    public class SearchObjectOwner {

        public SearchObjectOwner(SearchObjectLevel level) {
            
        }
    }
}