import { Routes, Route, BrowserRouter } from 'react-router-dom';
import App from '../pages/App';
import Profile from '../pages/Profile';
import { Header } from '../components/header';
import { FilmDetailPage } from '../pages/FilmDetailPage';

export const AppRoutes = () => {
	return (
		<BrowserRouter>
			<Header />
			<Routes>
				<Route path="/" element={<App />} />
				<Route path="profile" element={<Profile />} />
				<Route path="movie/:id" element={<FilmDetailPage />} />
			</Routes>
		</BrowserRouter>
	);
};
