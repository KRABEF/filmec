import { ContainerMain } from '../components/containerMain';

export default function App() {

	return (
		<div className="flex flex-col min-h-screen">
			<main className="flex flex-grow">
				<div className="w-90 sticky top-0 bg-neutral-900 p-4">Левое меню
				</div>
				<div className="flex-grow overflow-auto p-4 h-[calc(100vh-120px)]">
					<ContainerMain
						movies={[
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/0f1ddf5387cfbfd31303003237bd150a.jpg',
							},
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
							{
								id: 1,
								name: 'Колбаса',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
							{
								id: 1,
								name: 'The Witcher: Nightmare of the Wolf',
								release_date: '2025',
								genres: ['комедия', 'ужастик'],
								duration_movie: '2 мин.',
								rating: 5.3,
								ageLimit: '18+',
								poster: '/25630addd03346e5b2fccdeb32bf.jpg',
							},
						]}
					/>
				</div>
			</main>
		</div>
	);
}
