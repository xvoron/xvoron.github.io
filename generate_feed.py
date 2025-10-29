from pydantic import BaseModel


class Entry(BaseModel):
    title: str
    link: str
    description: str
    pubDate: str


class Feed(BaseModel):
    title: str
    description: str
    entries: list[dict]


def _title(line: str) -> str:
    return line.split('title:')[1].strip()

def _description(line: str) -> str:
    return line.split('description:')[1].strip()

def _parse_line(line: str) -> tuple[str | None, str | None]:
    match line:
        case line if line.startswith('title:'):
            return 'title', _title(line)
        case line if line.startswith('description:'):
            return 'description', _description(line)
        case _:
            return None, None



def gen_feed(path: str):
    with open(path, 'r') as f:
        data = f.read()     # md content
        front_matter = data.split('---')[1].strip()
        lines = front_matter.split('\n')
        metadata = {}
        for line in lines:
            key, value = _parse_line(line)
            if key and value:
                metadata[key] = value
        return metadata

if __name__ == "__main__":
    path = './posts/posts.md'
    metadata = gen_feed(path)
    print(metadata)
