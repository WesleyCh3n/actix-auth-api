import { ReactElement, useState } from "react";
import { AiOutlineLoading } from "react-icons/ai";

export interface ButtonProps {
  content: any;
  onClick(
    e: React.MouseEvent<HTMLButtonElement, MouseEvent>,
  ): any | Promise<any>;
  className?: string;
  disabled?: boolean;
}

export function AsyncButton(props: ButtonProps): ReactElement | null {
  const [isLoading, setIsLoading] = useState(false);
  return (
    <button
      className={`
        px-2 py-1 bg-blue-100 rounded-lg
        hover:bg-blue-200 active:bg-blue-300 disabled:bg-gray-300
        transition-all ease-in-out
        disabled:transform-none disabled:transition-none
        active:translate-y-[2px]
        ${props.className}`}
      onClick={async (e) => {
        setIsLoading(() => true);
        await props.onClick(e);
        setIsLoading(() => false);
      }}
      disabled={props.disabled || isLoading ? true : false}
    >
      {isLoading
        ? (
          <AiOutlineLoading
            className="flex justify-center items-center animate-spin"
            size={20}
          />
        )
        : (
          props.content
        )}
    </button>
  );
}

export function Button(props: ButtonProps): ReactElement | null {
  return (
    <button
      className={`
        px-2 py-1 bg-blue-100 rounded-lg
        hover:bg-blue-200 active:bg-blue-300 disabled:bg-gray-300
        transition-all ease-in-out
        disabled:transform-none disabled:transition-none
        active:translate-y-[2px]
        ${props.className}`}
      onClick={(e) => {
        props.onClick(e);
      }}
      disabled={props.disabled ? true : false}
    >
      {props.content}
    </button>
  );
}

// TODO:
/* export function ButtonOutline(props: ButtonProps): ReactElement | null {
  return (
    <button
      className={`
        py-1 px-2 text-gray-800 dark:text-gray-400 font-bold normal-case
        dark:bg-gray-700 shadow-sm
        border border-gray-400 dark:border-gray-600
        rounded-lg transition-all ease-in-out
        hover:bg-gray-400 dark:hover:bg-gray-600
        disabled:transform-none disabled:transition-none disabled:bg-gray-400
        disabled:dark:bg-gray-700 disabled:border-none
        active:translate-y-[2px]
        ${props.className}`}
      onClick={props.onClick}
      disabled={props.disabled ? true : false}
    >
      {props.isLoading ? (
        <AiOutlineLoading
          className="flex justify-center items-center animate-spin"
          size={20}
        />
      ) : (
        props.content
      )}
    </button>
  );
} */
