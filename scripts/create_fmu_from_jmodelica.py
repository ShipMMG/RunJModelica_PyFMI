import sys
from pymodelica import compile_fmu


def create_fmu_from_jmodelica(mo_file_path, name, version="2.0", target="cs"):
    """
    Create FMU file from Modelica file.
    Args:
        mo_file_path (str):
            File path of compiling target JModelica file.
        name (str):
            FMU name. FMU file name is "name.fmu"
        version (str, optional):
            FMI version. "1.0" or "2.0".
            Default to "2.0".
        target
            Model Exchange (me) or Co-Simulation (co)
            Default to "co".
    """
    compile_file_name = name + ".fmu"
    compile_fmu(
        name, mo_file_path, version=version, target=target, compile_to=compile_file_name
    )


if __name__ == "__main__":
    args = sys.argv
    try:
        if len(args) < 3:
            raise Exception(pymodelica
            create_fmu_from_jmodelica(args[1], args[2])
        elif len(args) == 4:
            create_fmu_from_jmodelica(args[1], args[2], args[3])
        elif len(args) == 5:
            create_fmu_from_jmodelica(args[1], args[2], args[3], args[4])
    except Exception as e:
        print("     e: %s" % e)
