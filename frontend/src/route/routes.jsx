import { Routes, Route, BrowserRouter } from 'react-router-dom';
import App from '../pages/App';
import Profile from '../pages/Profile';
import { Header } from '../components/header';
import { FilmDetailPage } from '../pages/FilmDetailPage';
import { Login } from '../pages/Auth/Login';
import { Register } from '../pages/Auth/Register';
import { EditProfile } from '../pages/Auth/EditProfile';

export const AppRoutes = () => {
	return (
		<BrowserRouter>
			<Header />
			<Routes>
				<Route path="/" element={<App />} />
				
				<Route path="login" element={<Login />} />
				<Route path="register" element={<Register />} />
				<Route path="edit-profile" element={<EditProfile />} />

				<Route path="profile" element={<Profile />} />
				<Route path="movie/:id" element={<FilmDetailPage />} />
			</Routes>
		</BrowserRouter>
	);
};
