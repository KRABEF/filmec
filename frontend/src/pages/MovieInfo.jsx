import { Button } from '../components/ui/button'

export const MovieInfo = () => {
    const film = {
        id: 1,
        name: 'Колбаса',
        release_date: '2025',
        genres: ['комедия', 'ужастик'],
        duration_movie: '2 мин.',
        rating: 5.3,
        ageLimit: '18+',
        poster: '/25630addd03346e5b2fccdeb32bf.jpg',
        description: ''
    }
    return <div className="max-w-full mx-auto lg:max-w-4/5 py-5 grid gap-5 grid-cols-1 lg:grid-cols-3 xl:grid-cols-4">
        <div className="
          flex gap-5
        bg-neutral-900 rounded-lg shadow-lg shadow-orange-500/40 p-4">
            <div className="">
                <img src={film.poster} alt={film.name} />
            </div>
            <div className="">
                <h2>{film.name}</h2>
                <p>{film.ageLimit}</p>
            </div>
            <div className="">
                <h3>О фильме</h3>
                <div className="gap-2 grid-cols-2">
                    <div>Год производства</div>
                    <div>{film.release_date}</div>

                </div>
            </div>
        </div>
    </div>
}