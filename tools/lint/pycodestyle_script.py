import pycodestyle
import re
import signal
import sys


def main():
    try:
        signal.signal(signal.SIGPIPE, lambda signum, frame: sys.exit(1))
    except AttributeError:
        pass

    style_guide = pycodestyle.StyleGuide(parse_argv=True)
    report = style_guide.check_files()

    if style_guide.options.statistics:
        report.print_statistics()

    if style_guide.options.benchmark:
        report.print_benchmark()

    if report.total_errors:
        if style_guide.options.count:
            print(report.total_errors, file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    sys.argv[0] = re.sub(r'_script\.py$', '', sys.argv[0])
    main()
