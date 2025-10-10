import Slider from 'react-slick';
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';

export const ActorCarousel = ({ actors }) => {
  const settings = {
    infinite: true,
    speed: 500,
    slidesToShow: 5,
    slidesToScroll: 1,
    initialSlide: 0,
    nextArrow: <NextArrow />,
    prevArrow: <PrevArrow />,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
          slidesToScroll: 4,
        },
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 3,
        },
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        },
      },
    ],
  };

  return (
    <div className="relative">
      <h3 className="text-2xl font-bold text-white flex items-center gap-2 mb-7">
        Режиссёры и актёры
      </h3>
      <div className="slider-container relative mx-18">
        <Slider {...settings}>
          {actors.map((actor) => (
            <div key={actor.id} className="px-2">
              <div className="flex flex-col items-center cursor-pointer transition-all duration-300">
                <div className="relative">
                  {actor.photo ? (
                    <img
                      src={actor.photo}
                      alt={actor.name}
                      className="w-40 h-40 rounded-full object-cover mx-auto"
                    />
                  ) : (
                    <div className="w-40 h-40 rounded-full bg-neutral-600 flex items-center justify-center text-neutral-200 text-3xl">
                      {actor.name[0]}
                    </div>
                  )}
                </div>
                <div className="mt-3 text-center">
                  <div className="text-sm text-neutral-200">
                    {actor.name} {actor.isDirector && <p className="text-neutral-400">Режиссёр</p>}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </Slider>
      </div>
    </div>
  );
};

const ArrowButton = ({ children, onClick, direction }) => {
  return (
    <button
      onClick={onClick}
      className={`p-4 rounded-full bg-neutral-900/70 hover:bg-orange-600 hover:text-white text-neutral-300 transition-all shadow-lg absolute top-1/2 transform -translate-y-1/2 z-10 ${
        direction === 'prev' ? '-left-18' : '-right-18'
      }`}
    >
      {children}
    </button>
  );
};

const NextArrow = ({ onClick }) => {
  return (
    <ArrowButton onClick={onClick} direction="next">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        className="bi bi-chevron-right"
        viewBox="0 0 16 16"
      >
        <path
          fillRule="evenodd"
          d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"
        />
      </svg>
    </ArrowButton>
  );
};

const PrevArrow = ({ onClick }) => {
  return (
    <ArrowButton onClick={onClick} direction="prev">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        className="bi bi-chevron-left"
        viewBox="0 0 16 16"
      >
        <path
          fillRule="evenodd"
          d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"
        />
      </svg>
    </ArrowButton>
  );
};
