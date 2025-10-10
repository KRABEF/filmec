export const Avatar = ({ height = 'h-10', width = 'w-10' }) => {
  return <div className = {`rounded-full overflow-hidden h-10 w-10 mr-2 flex-shrink-0 ${width},${height}`}>
        <img src="/ivan.jpg"></img>
    </div>
}