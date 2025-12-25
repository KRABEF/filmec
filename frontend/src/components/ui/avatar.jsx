export const Avatar = ({ height = 'h-10', width = 'w-10', src }) => {
  return <div className = {`rounded-full overflow-hidden mr-2 flex-shrink-0 ${width} ${height}`}>
        <img src={src}></img>
    </div>
}