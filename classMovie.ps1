class Movie {
    [string]$title = ""
    [string]$id = ""
    $genreIds = @()
    $vote = 0
    $releaseDate = 0
    $description
    $urlToImg = $null
    $urlToWatch

    Movie($id, $title, $genreIds, $vote, $releaseDate, $description,$urlToImg,$urlToWatch){
        $this.title = $title
        $this.id = $id
        $this.genreIds = $genreIds 
        $this.vote = $vote
        $this.releaseDate = $releaseDate
        $this.description = $description
        $this.urlToWatch = $urlToWatch
        if($null -eq $urlToImg){
            $this.urlToImg = "$null"
        } else {
            $this.urlToImg = "https://image.tmdb.org/t/p/w185$urlToImg"
        }

    }

}