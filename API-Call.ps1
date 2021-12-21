Import-Module .\classMovie.ps1

function New-Movie ($movie, $url){
    $id = $movie.id
    $title = $movie.title
    $genreIds = $movie.genre_ids
    $vote = $movie.vote_average
    $release = $movie.release_date
    $description = $movie.overview
    $urlToImg = $movie.poster_path
    return New-Object Movie -ArgumentList @($id, $title, $genreIds, $vote, $release,$description,$urlToImg,$url)
}

class APIcall{
    $uriMovies = "https://api.themoviedb.org/3"

    static [string]SearchURL($id){
        $uri = "https://api.themoviedb.org/3"
        $Body = @{
            api_key = "9322a6d4ca54ae23e8b1a59f05fbd872"
        }
        $response = Invoke-WebRequest -Uri ($uri+"/movie/"+$id+"/watch/providers") -Body $Body | ConvertFrom-Json

        return $response.results.AR.link

    }

    [void] AddMovie([Object[]]$array,[System.Collections.ArrayList]$addTo){
        for($i = 0; $i -lt $array.Count; $i++){
            if(!$addTo.Contains($array[$i])){
                $url = [APIcall]::SearchURL($array[$i].id)
                if(-not [System.String]::IsNullOrEmpty($url)){ 
                    $movie = New-Movie($array[$i],$url)
                    if(!($null -eq $movie.urlToImg)){
                        Invoke-WebRequest (""+$movie.UrlToImg) -OutFile (".\Posters\"+$movie.id+".jpg")
                    }
                    $addTo.Add($movie)
                }
            }

        }
    }
    
    [object[]] SearchYear($year,$page) {
        $movies = [System.Collections.ArrayList]@{}

        $Body = @{
            api_key = "9322a6d4ca54ae23e8b1a59f05fbd872"
            sort_by = "release_date.desc"
            page=$page
            year = "$year"
            with_original_language="en"
        }

        $discoverMovies = Invoke-WebRequest -Uri ($this.uriMovies+"/discover/movie") -Body $Body | ConvertFrom-Json

        $this.AddMovie($discoverMovies.results,$movies)
        
        return $movies
    }


    [object[]] SearchGenre($genre,$page) {
        $movies = [System.Collections.ArrayList]@{}

        $Body = @{
            api_key = "9322a6d4ca54ae23e8b1a59f05fbd872"
            sort_by = "popularity.asc"
            page = $page
            with_genres = "$genre"
        }

        $discoverMovies = Invoke-WebRequest -Uri ($this.uriMovies+"/discover/movie") -Body $Body | ConvertFrom-Json

        
        
        $this.AddMovie($discoverMovies.results,$movies)
        return $movies
    }


}

